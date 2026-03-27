const http = require('http');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const { URL } = require('url');

loadEnvFile();

const env = {
  port: Number(process.env.PORT || 8080),
  appOrigin: process.env.APP_ORIGIN || 'http://localhost:3000',
  paymentProvider: process.env.PAYMENT_PROVIDER || 'mock',
  webhookSecret:
    process.env.PAYMENT_WEBHOOK_SECRET || 'replace-with-a-long-random-secret',
  midtransServerKey: process.env.MIDTRANS_SERVER_KEY || '',
  midtransClientKey: process.env.MIDTRANS_CLIENT_KEY || '',
  midtransIsProduction: process.env.MIDTRANS_IS_PRODUCTION === 'true',
  dataDir: process.env.DATA_DIR || path.join(process.cwd(), 'data'),
};

const paymentsFilePath = path.join(env.dataDir, 'payments.json');
const payments = loadPaymentsStore();

function loadEnvFile() {
  const envPath = path.join(process.cwd(), '.env');

  if (!fs.existsSync(envPath)) {
    return;
  }

  const content = fs.readFileSync(envPath, 'utf8');
  for (const line of content.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) {
      continue;
    }

    const separatorIndex = trimmed.indexOf('=');
    if (separatorIndex === -1) {
      continue;
    }

    const key = trimmed.slice(0, separatorIndex).trim();
    const value = trimmed.slice(separatorIndex + 1).trim();

    if (!(key in process.env)) {
      process.env[key] = value;
    }
  }
}

function ensureDataDir() {
  fs.mkdirSync(env.dataDir, { recursive: true });
}

function loadPaymentsStore() {
  ensureDataDir();

  if (!fs.existsSync(paymentsFilePath)) {
    fs.writeFileSync(paymentsFilePath, '[]', 'utf8');
    return new Map();
  }

  try {
    const raw = fs.readFileSync(paymentsFilePath, 'utf8');
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) {
      return new Map();
    }

    return new Map(parsed.map((item) => [item.orderId, item]));
  } catch (_) {
    return new Map();
  }
}

function persistPaymentsStore() {
  ensureDataDir();
  const serialized = JSON.stringify([...payments.values()], null, 2);
  fs.writeFileSync(paymentsFilePath, serialized, 'utf8');
}

function resolveAllowedOrigin(origin) {
  if (!origin) {
    return env.appOrigin;
  }

  try {
    const parsed = new URL(origin);
    const isLocalhost =
      parsed.hostname === 'localhost' || parsed.hostname === '127.0.0.1';

    if (isLocalhost) {
      return origin;
    }
  } catch (_) {
    return env.appOrigin;
  }

  return origin === env.appOrigin ? origin : env.appOrigin;
}

function sendJson(res, statusCode, payload, origin) {
  const body = JSON.stringify(payload);
  const allowedOrigin = resolveAllowedOrigin(origin);
  res.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(body),
    'Access-Control-Allow-Origin': allowedOrigin,
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, X-Diresto-Signature',
  });
  res.end(body);
}

function sendNoContent(res, origin) {
  const allowedOrigin = resolveAllowedOrigin(origin);
  res.writeHead(204, {
    'Access-Control-Allow-Origin': allowedOrigin,
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, X-Diresto-Signature',
  });
  res.end();
}

function readJsonBody(req) {
  return new Promise((resolve, reject) => {
    let raw = '';
    req.on('data', (chunk) => {
      raw += chunk;
    });
    req.on('end', () => {
      if (!raw) {
        resolve({});
        return;
      }

      try {
        resolve(JSON.parse(raw));
      } catch (error) {
        reject(new Error('Request body must be valid JSON.'));
      }
    });
    req.on('error', reject);
  });
}

function createPaymentId() {
  return `pay_${crypto.randomBytes(6).toString('hex')}`;
}

function nowIso() {
  return new Date().toISOString();
}

function buildVirtualAccount(bankCode) {
  const suffix = Math.floor(10000000 + Math.random() * 89999999);
  return `${bankCode}${suffix}`;
}

function buildMockInstructions(paymentMethod, amount, provider) {
  switch (paymentMethod) {
    case 'qris':
      return {
        type: 'qris',
        qrContent: `DIRESTO.${amount}.${Date.now()}`,
        expiresAt: new Date(Date.now() + 15 * 60 * 1000).toISOString(),
      };
    case 'e_wallet':
      return {
        type: 'e_wallet',
        provider,
        deeplinkUrl: `https://sandbox.diresto.test/pay/${provider}`,
        accountReference: `${provider?.toUpperCase() || 'EWALLET'}-${Date.now()
          .toString()
          .slice(-8)}`,
      };
    case 'transfer_va':
      return {
        type: 'transfer_va',
        bank: provider || 'bca',
        vaNumber: buildVirtualAccount(
          provider === 'bri' ? '8808002' : provider === 'bni' ? '8808009' : '8808014',
        ),
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
      };
    default:
      return {
        type: 'cashier',
        message: 'Waiting for cashier confirmation.',
      };
  }
}

function validateCreatePayment(payload) {
  if (!payload.orderId || typeof payload.orderId !== 'string') {
    return 'orderId is required.';
  }

  if (!Number.isFinite(payload.amount) || payload.amount <= 0) {
    return 'amount must be a positive number.';
  }

  if (!payload.paymentMethod || typeof payload.paymentMethod !== 'string') {
    return 'paymentMethod is required.';
  }

  if (!Array.isArray(payload.items) || payload.items.length === 0) {
    return 'items must be a non-empty array.';
  }

  return null;
}

async function createPaymentHandler(req, res) {
  const origin = req.headers.origin;
  const payload = await readJsonBody(req);
  const validationError = validateCreatePayment(payload);

  if (validationError) {
    sendJson(res, 400, { error: validationError }, origin);
    return;
  }

  const paymentId = createPaymentId();
  const instructions = buildMockInstructions(
    payload.paymentMethod,
    payload.amount,
    payload.provider,
  );

  const payment = {
    paymentId,
    orderId: payload.orderId,
    amount: payload.amount,
    items: payload.items,
    paymentMethod: payload.paymentMethod,
    provider: payload.provider || null,
    status: payload.paymentMethod === 'cashier' ? 'waiting_cashier' : 'pending',
    customer: payload.customer || null,
    createdAt: nowIso(),
    updatedAt: nowIso(),
    instructions,
    providerMode: env.paymentProvider,
  };

  payments.set(payload.orderId, payment);
  persistPaymentsStore();

  sendJson(
    res,
    201,
    {
    message: 'Payment created.',
    payment,
    nextSteps:
      env.paymentProvider === 'mock'
        ? [
            'Gunakan endpoint simulate-paid untuk menguji alur sukses.',
            'Saat siap ke production, ganti PAYMENT_PROVIDER dan sambungkan gateway nyata.',
          ]
        : ['Gateway provider integration is enabled.'],
    },
    origin,
  );
}

async function simulatePaidHandler(req, res, orderId) {
  const origin = req.headers.origin;
  const payment = payments.get(orderId);

  if (!payment) {
    sendJson(res, 404, { error: 'Payment not found.' }, origin);
    return;
  }

  payment.status = 'paid';
  payment.updatedAt = nowIso();
  payment.paidAt = nowIso();
  persistPaymentsStore();

  sendJson(res, 200, {
    message: 'Payment marked as paid in sandbox.',
    payment,
  }, origin);
}

async function getPaymentStatusHandler(req, res, orderId) {
  const origin = req.headers.origin;
  const payment = payments.get(orderId);

  if (!payment) {
    sendJson(res, 404, { error: 'Payment not found.' }, origin);
    return;
  }

  sendJson(res, 200, { payment }, origin);
}

async function webhookHandler(req, res) {
  const origin = req.headers.origin;
  const signature = req.headers['x-diresto-signature'];

  if (!signature) {
    sendJson(res, 401, { error: 'Missing webhook signature.' }, origin);
    return;
  }

  const payload = await readJsonBody(req);
  const expected = crypto
    .createHmac('sha256', env.webhookSecret)
    .update(JSON.stringify(payload))
    .digest('hex');

  if (signature !== expected) {
    sendJson(res, 401, { error: 'Invalid webhook signature.' }, origin);
    return;
  }

  const payment = payments.get(payload.orderId);
  if (!payment) {
    sendJson(res, 404, { error: 'Payment not found.' }, origin);
    return;
  }

  payment.status = payload.status || payment.status;
  payment.updatedAt = nowIso();
  if (payload.status === 'paid') {
    payment.paidAt = nowIso();
  }
  persistPaymentsStore();

  sendJson(res, 200, {
    message: 'Webhook accepted.',
    payment,
  }, origin);
}

function routes(req, res) {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const origin = req.headers.origin;

  if (req.method === 'OPTIONS') {
    sendNoContent(res, origin);
    return;
  }

  if (req.method === 'GET' && url.pathname === '/health') {
    sendJson(res, 200, {
      status: 'ok',
      provider: env.paymentProvider,
      timestamp: nowIso(),
      storage: paymentsFilePath,
      paymentsCount: payments.size,
    }, origin);
    return;
  }

  if (req.method === 'POST' && url.pathname === '/api/payments/create') {
    createPaymentHandler(req, res).catch((error) => {
      sendJson(
        res,
        500,
        { error: error.message || 'Failed to create payment.' },
        origin,
      );
    });
    return;
  }

  if (req.method === 'POST' && url.pathname === '/api/payments/webhook') {
    webhookHandler(req, res).catch((error) => {
      sendJson(
        res,
        500,
        { error: error.message || 'Failed to process webhook.' },
        origin,
      );
    });
    return;
  }

  const statusMatch = url.pathname.match(/^\/api\/payments\/([^/]+)$/);
  if (req.method === 'GET' && statusMatch) {
    getPaymentStatusHandler(req, res, statusMatch[1]).catch((error) => {
      sendJson(
        res,
        500,
        { error: error.message || 'Failed to get payment status.' },
        origin,
      );
    });
    return;
  }

  const simulateMatch = url.pathname.match(/^\/api\/payments\/([^/]+)\/simulate-paid$/);
  if (req.method === 'POST' && simulateMatch) {
    simulatePaidHandler(req, res, simulateMatch[1]).catch((error) => {
      sendJson(
        res,
        500,
        { error: error.message || 'Failed to simulate payment.' },
        origin,
      );
    });
    return;
  }

  sendJson(res, 404, { error: 'Route not found.' }, origin);
}

const server = http.createServer(routes);

server.listen(env.port, () => {
  console.log(
    `[diresto-backend] Listening on http://localhost:${env.port} using provider=${env.paymentProvider}`,
  );
});
