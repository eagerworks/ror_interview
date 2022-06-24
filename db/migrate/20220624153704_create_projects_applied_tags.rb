class CreateProjectsAppliedTags < ActiveRecord::Migration[7.0]
  def change
    create_table :projects_applied_tags do |t|
      t.references :project, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: {to_table: "projects_tags"}

      t.timestamps
    end
  end
end
