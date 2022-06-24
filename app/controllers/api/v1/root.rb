class Api::V1::Root < Api::Base
  include Api::V1::Base

  mount Api::V1::ProjectsEndpoint
  mount Api::V1::Projects::TagsEndpoint
  mount Api::V1::InvoicesEndpoint
  # 🚅 super scaffolding will mount new endpoints above this line.

  handle_not_found
end
