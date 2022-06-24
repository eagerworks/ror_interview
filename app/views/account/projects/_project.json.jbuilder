json.extract! project,
  :id,
  :team_id,
  :name,
  :tag_ids,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_project_url(project, format: :json)
