class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.string    :login,         :null => false
      t.integer   :gh_id,         :null => false
      t.string    :url
      t.string    :html_url
      t.string    :name
      t.string    :location
      t.string    :email
      t.datetime  :gh_created_at
      t.integer   :public_repos
      t.integer   :private_repos

      t.references :user

      t.timestamps
    end
  end
end