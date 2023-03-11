class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :dictionary_form, null: false
      t.string :language, null: false

      t.timestamps
    end
  end
end
