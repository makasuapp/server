json.user do
  json.(@user, :id, :role, :first_name, :last_name, :email, :phone_number)

  #TODO(permissions): this should instead be the organizations / kitchens actually have access to
  json.organizations(@user.user_organizations) do |user_org|
    organization = user_org.organization
    json.id user_org.organization_id
    json.name organization.name
    json.extract! user_org, :role, :kitchen_id

    json.kitchens(organization.kitchens) do |kitchen|
      json.extract! kitchen, :id, :name
      json.access_link user_org.access_link
    end
  end
end

json.token @user.generate_jwt
