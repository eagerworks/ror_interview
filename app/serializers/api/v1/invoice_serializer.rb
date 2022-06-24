class Api::V1::InvoiceSerializer < Api::V1::ApplicationSerializer
  set_type "invoice"

  attributes :id,
    :team_id,
    :description,
    :total,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
