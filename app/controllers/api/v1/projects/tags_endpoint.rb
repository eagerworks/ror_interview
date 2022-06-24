class Api::V1::Projects::TagsEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Tag ID"
    end

    params :tag do
      optional :name, type: String, desc: Api.heading(:name)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Projects::Tag
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/projects/tags" do
      @paginated_tags = paginate @tags
      render @paginated_tags, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :tag
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/projects/tags" do
      if @tag.save
        render @tag, serializer: Api.serializer
      else
        record_not_saved @tag
      end
    end
  end

  resource "projects/tags", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Projects::Tag
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @tag, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :tag
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @tag.update(declared(params, include_missing: false))
          render @tag, serializer: Api.serializer
        else
          record_not_saved @tag
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @tag.destroy, serializer: Api.serializer
      end
    end
  end
end
