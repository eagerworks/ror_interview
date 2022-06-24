class Api::V1::ProjectSerializer < Api::V1::ApplicationSerializer
  set_type "project"

  attributes :id,
    :team_id,
    :name,
    :tag_ids,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
