class CreateHeadings::V20180104171627 < LuckyMigrator::Migration::V1
  def migrate
    create :headings do
      belongs_to Chapter, on_delete: :cascade
      add code : String, unique: true
      add description : String
    end

    execute "CREATE UNIQUE INDEX headings_chapter_id_code_index ON headings USING btree (chapter_id, code);"
  end

  def rollback
    drop :headings
  end
end
