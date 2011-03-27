class CreateFeatureSwitches < ActiveRecord::Migration
    def self.up
      create_table :feature_switches do |t|
        t.string :name
        t.boolean :enabled, :default => false
      end
    end

    def self.down
      drop_table :features
    end
end
