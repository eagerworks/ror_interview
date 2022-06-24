json.extract! invoice,
  :id,
  :team_id,
  :description,
  :total,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_invoice_url(invoice, format: :json)
