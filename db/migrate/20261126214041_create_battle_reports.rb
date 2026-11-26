class CreateBattleReports < ActiveRecord::Migration[8.1]
  def change
    create_table :battle_reports do |t|
      t.references :round, null: false, foreign_key: true
      t.references :squad, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
