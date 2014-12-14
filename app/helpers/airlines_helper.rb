module AirlinesHelper

  def sortable(column, title=nil)
    direction = (column.to_s == sort_column.to_s && sort_direction == "asc") ? "desc" : "asc"
    title ||= column
    if (sort_column.to_s == column.to_s)
      title += direction == "asc" ? "\u25b2" : "\u25bc"
    end
    link_to title, { sort:column, direction:direction }, { id:"sort-by-#{column}" }
  end

end
