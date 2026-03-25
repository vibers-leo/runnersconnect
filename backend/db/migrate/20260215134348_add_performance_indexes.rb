class AddPerformanceIndexes < ActiveRecord::Migration[8.1]
  def change
    # Registrations 테이블 복합 인덱스 (race_edition_id 사용)
    add_index :registrations, [:race_edition_id, :status], name: 'index_registrations_on_edition_and_status'
    add_index :registrations, [:status, :created_at], name: 'index_registrations_on_status_and_created_at'

    # Records 테이블 복합 인덱스
    add_index :records, [:race_edition_id, :net_time], name: 'index_records_on_race_edition_id_and_net_time'
    unless index_exists?(:records, :registration_id)
      add_index :records, :registration_id, name: 'index_records_on_registration_id'
    end

    # Users 테이블 복합 인덱스
    add_index :users, [:gender, :age_group], name: 'index_users_on_gender_and_age_group'

    # Products 테이블 복합 인덱스
    add_index :products, [:race_id, :status, :stock], name: 'index_products_on_race_id_status_and_stock'

    # Orders 테이블 인덱스
    add_index :orders, [:user_id, :status], name: 'index_orders_on_user_id_and_status'
    add_index :orders, [:race_id, :status], name: 'index_orders_on_race_id_and_status'
  end
end
