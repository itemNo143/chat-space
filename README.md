# ChatSpace DB 設計

## groups_users テーブル

| Column   | Type    | Options                        |
| -------- | ------- | ------------------------------ |
| user_id  | integer | null: false, foreign_key: true |
| group_id | integer | null: false, foreign_key: true |

### Association

- belongs_to :group
- belongs_to :user

## users テーブル

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| email    | string | null: false |
| password | string | null: false |
| name     | string | null: false |

### Association

- has_many :messages
- has_many :groups_users
- has_many :groups, through: :groups_users

## messages テーブル

| Column   | Type    | Options                        |
| -------- | ------- | ------------------------------ |
| image    | text    |                                |
| text     | text    |                                |
| user_id  | integer | null: false, foreign_key: true |
| group_id | integer | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :group

## groups テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :messages
- has_many :groups_users
- has_many :users, through: :groups_users
