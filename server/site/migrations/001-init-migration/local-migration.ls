require! {
	\../../models/models : {ContentPage, DiffData}
	\../../../adm/models/models : {User}
	\./data
}

init-user = new User data.users.0
init-user.save!

for item in data.content-pages
	page = new ContentPage item
	page.save!

