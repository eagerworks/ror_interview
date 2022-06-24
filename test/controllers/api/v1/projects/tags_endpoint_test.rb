require "test_helper"
require "controllers/api/test"

class Api::V1::Projects::TagsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @tag = create(:projects_tag, team: @team)
      @other_tags = create_list(:projects_tag, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(tag_data)
      # Fetch the tag in question and prepare to compare it's attributes.
      tag = Projects::Tag.find(tag_data["id"])

      assert_equal tag_data['name'], tag.name
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal tag_data["team_id"], tag.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/projects/tags", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      tag_ids_returned = response.parsed_body.dig("data").map { |tag| tag.dig("attributes", "id") }
      assert_includes(tag_ids_returned, @tag.id)

      # But not returning other people's resources.
      assert_not_includes(tag_ids_returned, @other_tags[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/projects/tags/#{@tag.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/projects/tags/#{@tag.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      tag_data = Api::V1::Projects::TagSerializer.new(build(:projects_tag, team: nil)).serializable_hash.dig(:data, :attributes)
      tag_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/projects/tags",
        params: tag_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/projects/tags",
        params: tag_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/projects/tags/#{@tag.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @tag.reload
      assert_equal @tag.name, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/projects/tags/#{@tag.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Projects::Tag.count", -1) do
        delete "/api/v1/projects/tags/#{@tag.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/projects/tags/#{@tag.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
