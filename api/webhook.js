/**
 * Vercel Serverless Function - Webhook para Paradise Pags
 *
 * Deploy: git push (automático)
 * URL: https://seudominio.vercel.app/api/webhook
 *
 * Estrutura de pastas necessária:
 * project/
 * ├── api/
 * │   └── webhook.js (este arquivo)
 * ├── vercel.json
 * └── package.json
 */

// Configurações Supabase
const SUPABASE_URL = "https://dcahduxatuajbnsecuzz.supabase.co";
const SUPABASE_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjYWhkdXhhdHVhamJuc2VjdXp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1ODU2NDcsImV4cCI6MjA3OTE2MTY0N30.sIvEQPYGmuLQUi6kJu-F6PBcjZIQJ_I4Ui-FBUDcwBU";
const SUPABASE_TABLE = "pedidos";

/**
 * Função helper para log
 */
function log(message) {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${message}`);
}

/**
 * Handler principal
 */
module.exports = async function handler(req, res) {
  // CORS
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  // Handle preflight
  if (req.method === "OPTIONS") {
    res.status(204).end();
    return;
  }

  // Apenas POST
  if (req.method !== "POST") {
    return res
      .status(405)
      .json({ error: "Apenas requisições POST são aceitas" });
  }

  try {
    const data = req.body;
    log("Webhook recebido: " + JSON.stringify(data));

    // Processar pagamento aprovado
    if (data.event === "payment_approved") {
      return await handlePaymentApproved(data, res);
    }

    // Processar pagamento recusado
    if (data.event === "payment_failed") {
      return await handlePaymentFailed(data, res);
    }

    // Evento desconhecido
    log("Evento desconhecido: " + (data.event || "sem event"));
    return res
      .status(200)
      .json({ message: "Evento recebido mas não processado" });
  } catch (error) {
    log("Erro ao processar: " + error.message);
    return res
      .status(400)
      .json({ error: "JSON inválido ou erro no processamento" });
  }
};

/**
 * Processa pagamento aprovado
 */
async function handlePaymentApproved(data, res) {
  const transaction_id = data.transaction_id ?? null;
  const order_id = data.reference ?? null;
  const pix_key = data.qr_code ?? null;
  const amount = data.amount ? data.amount / 100 : 0; // Converter de centavos
  const paid_at = data.paid_at ?? new Date().toISOString();

  log(`Processando pagamento aprovado - Transaction ID: ${transaction_id}`);

  if (!transaction_id || !order_id) {
    log("Erro: Transaction ID ou Order ID não fornecidos");
    return res
      .status(400)
      .json({ error: "Transaction ID ou Order ID não fornecidos" });
  }

  try {
    // Buscar pedido existente
    const searchResponse = await fetch(
      `${SUPABASE_URL}/rest/v1/${SUPABASE_TABLE}?order_id=eq.${order_id}`,
      {
        method: "GET",
        headers: {
          apikey: SUPABASE_KEY,
          Authorization: `Bearer ${SUPABASE_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    log(`Busca de pedido existente - HTTP ${searchResponse.status}`);

    if (searchResponse.ok) {
      const existingOrders = await searchResponse.json();

      if (existingOrders && existingOrders.length > 0) {
        // Pedido existe, atualizar
        const orderId = existingOrders[0].id;
        log(`Pedido encontrado - ID: ${orderId}. Atualizando status...`);

        const updateData = {
          status: "pix_paid",
          transaction_id: transaction_id,
          paid_at: paid_at,
          updated_at: new Date().toISOString(),
        };

        const updateResponse = await fetch(
          `${SUPABASE_URL}/rest/v1/${SUPABASE_TABLE}?id=eq.${orderId}`,
          {
            method: "PATCH",
            headers: {
              apikey: SUPABASE_KEY,
              Authorization: `Bearer ${SUPABASE_KEY}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify(updateData),
          }
        );

        log(`Atualização de status - HTTP ${updateResponse.status}`);

        if (updateResponse.ok) {
          log("✅ Sucesso! Pedido atualizado.");
          return res.status(200).json({
            success: true,
            message: "Pagamento confirmado e pedido atualizado",
            order_id: order_id,
            transaction_id: transaction_id,
          });
        } else {
          const error = await updateResponse.text();
          log(`❌ Erro ao atualizar pedido: ${error}`);
          return res
            .status(500)
            .json({ error: "Erro ao atualizar pedido no banco" });
        }
      } else {
        // Pedido não existe, criar novo
        log("Pedido não encontrado. Criando novo registro...");

        const newOrder = {
          order_id: order_id,
          transaction_id: transaction_id,
          pix_key: pix_key,
          amount: amount,
          status: "pix_paid",
          customer: data.customer || {},
          address: data.address || {},
          items: data.items || [],
          paid_at: paid_at,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        };

        const createResponse = await fetch(
          `${SUPABASE_URL}/rest/v1/${SUPABASE_TABLE}`,
          {
            method: "POST",
            headers: {
              apikey: SUPABASE_KEY,
              Authorization: `Bearer ${SUPABASE_KEY}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify(newOrder),
          }
        );

        log(`Criação de novo pedido - HTTP ${createResponse.status}`);

        if (createResponse.ok) {
          log("✅ Sucesso! Novo pedido criado.");
          return res.status(200).json({
            success: true,
            message: "Novo pedido criado e marcado como pago",
            order_id: order_id,
            transaction_id: transaction_id,
          });
        } else {
          const error = await createResponse.text();
          log(`❌ Erro ao criar pedido: ${error}`);
          return res
            .status(500)
            .json({ error: "Erro ao criar pedido no banco" });
        }
      }
    }
  } catch (error) {
    log(`❌ Exceção: ${error.message}`);
    return res.status(500).json({ error: "Erro interno: " + error.message });
  }
}

/**
 * Processa pagamento recusado
 */
async function handlePaymentFailed(data, res) {
  const order_id = data.reference ?? null;
  log(`Pagamento recusado para Order ID: ${order_id}`);

  if (!order_id) {
    return res.status(400).json({ error: "Order ID não fornecido" });
  }

  try {
    const updateData = {
      status: "pix_failed",
      updated_at: new Date().toISOString(),
    };

    const updateResponse = await fetch(
      `${SUPABASE_URL}/rest/v1/${SUPABASE_TABLE}?order_id=eq.${order_id}`,
      {
        method: "PATCH",
        headers: {
          apikey: SUPABASE_KEY,
          Authorization: `Bearer ${SUPABASE_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(updateData),
      }
    );

    log(`Atualização de falha de pagamento - HTTP ${updateResponse.status}`);

    return res.status(200).json({
      success: true,
      message: "Pagamento marcado como recusado",
      order_id: order_id,
    });
  } catch (error) {
    log(`❌ Erro ao processar falha: ${error.message}`);
    return res.status(500).json({ error: "Erro ao processar falha" });
  }
}
