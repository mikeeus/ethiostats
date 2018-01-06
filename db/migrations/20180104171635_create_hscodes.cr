class CreateHscodes::V20180104171635 < LuckyMigrator::Migration::V1
  def migrate
    create :hscodes do
      belongs_to Section, on_delete: :cascade
      belongs_to Chapter, on_delete: :cascade
      belongs_to Heading, on_delete: :cascade

      add code : String, unique: true
      add description : String
      add unit : String, default: "UN"
      add special_permission : String?

      add duty : Int32, default: 0
      add excise : Int32, default: 0
      add vat : Int32, default: 15
      add sur : Int32, default: 10
      add withholding : Int32, default: 3
      add ss_1 : Int32?
      add ss_2 : Int32?
    end

    execute "CREATE INDEX hscodes_section_chapter_heading_index ON hscodes USING btree (section_id, chapter_id, heading_id);"
  end

  def rollback
    drop :hscodes
  end
end
