ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :on_sale, :new_arrival, :image, category_ids: []

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :on_sale
      f.input :new_arrival
      f.input :categories, as: :check_boxes, collection: Category.all
      f.input :image, as: :file  # Enables image upload
    end
    f.actions
  end

  # Display image in the index and show pages
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :on_sale
    column :new_arrival
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), width: 50
      else
        "No image"
      end
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :on_sale
      row :new_arrival
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), width: 200
        else
          "No image available"
        end
      end
    end
    active_admin_comments
  end
end
