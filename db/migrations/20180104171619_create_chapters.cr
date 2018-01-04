class CreateChapters::V20180104171619 < LuckyMigrator::Migration::V1
  def migrate
    create :chapters do
      belongs_to Section, on_delete: :cascade
      add code : String, unique: true
      add description : String
    end

    execute "CREATE UNIQUE INDEX chapters_section_id_code_index ON chapters USING btree (section_id, code);"
  end

  def rollback
    drop :chapters
  end
end
