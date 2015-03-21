module ProductsHelper

  def selected_tag_link(type)
    selected_tags.map do |tag_name|
      link_to(tag_name, tag_products_path(type: type, tag_name: tag_name), class: 'selected_tag btn btn-default btn-xs')
    end.join(' ')
  end

  def selected_tags
    return @selected_tags if defined?(@selected_tags)
    @selected_tags = params['product'] ?
      params['product'].select { |k, v| !k.match(/price/) }.values().flatten :
      []
    @selected_tags << params[:tag_name] if params[:tag_name].present?
    @selected_tags << params[:q] if params[:q].present?
    @selected_tags
  end
end
