class CreateSections::V20180104171609 < LuckyMigrator::Migration::V1
  def migrate
    create :sections do
      add code : String, unique: true
      add description : String
    end
  end

  def rollback
    drop :sections
  end
end
