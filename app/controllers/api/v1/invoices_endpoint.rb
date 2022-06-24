class Api::V1::InvoicesEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Invoice ID"
    end

    params :invoice do
      optional :description, type: String, desc: Api.heading(:description)
      optional :total, type: String, desc: Api.heading(:total)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Invoice
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
    get "/:team_id/invoices" do
      @paginated_invoices = paginate @invoices
      render @paginated_invoices, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :invoice
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/invoices" do
      if @invoice.save
        render @invoice, serializer: Api.serializer
      else
        record_not_saved @invoice
      end
    end
  end

  resource "invoices", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Invoice
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
        render @invoice, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :invoice
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @invoice.update(declared(params, include_missing: false))
          render @invoice, serializer: Api.serializer
        else
          record_not_saved @invoice
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
        render @invoice.destroy, serializer: Api.serializer
      end
    end
  end
end
