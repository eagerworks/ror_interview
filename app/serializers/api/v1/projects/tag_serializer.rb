class Api::V1::Projects::TagSerializer < Api::V1::ApplicationSerializer
  set_type "projects/tag"

  attributes :id,
    :team_id,
    :name,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
