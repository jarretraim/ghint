class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.string    :login,         :null => false
      t.integer   :gh_id,         :null => false
      t.string    :url,           :null => false
      t.string    :html_url,      :null => false
      t.string    :name,          :null => false
      t.string    :location,      :null => false
      t.string    :email,         :null => false
      t.datetime  :gh_created_at, :null => false
      t.integer   :public_repos,  :null => false
      t.integer   :private_repos, :null => false

      t.references :user

      t.timestamps
    end
  end
end