# coding: utf-8
<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: false' unless attribute.required? %>
<% end -%>
<% attributes.select(&:token?).each do |attribute| -%>
  has_secure_token<% if attribute.name != "token" %> :<%= attribute.name %><% end %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>

  class Search
    include ActiveModel::Model
    include ActiveModelBase

<%-
attrs_with_type = attributes.group_by(&:type)
search_attrs = {
  text: [
      attrs_with_type[:string],
      attrs_with_type[:text]
    ].flatten.compact.map(&:name),
  date:
    (attrs_with_type[:date] || []).map{ |attr|
      ["#{attr.name}_from", "#{attr.name}_to"]
    }.flatten,
  date_time: [
      attrs_with_type[:datetime],
      attrs_with_type[:timestamp],
      attrs_with_type[:time]
    ].flatten.compact.map{ |attr|
      ["#{attr.name}_from", "#{attr.name}_to"]
    }.flatten,
  integer:
    (attrs_with_type[:integer] || []).map{ |attr|
      ["#{attr.name}_from", "#{attr.name}_to"]
    }.flatten,
  float: [
      attrs_with_type[:float],
      attrs_with_type[:decimal]
    ].flatten.compact.map{ |attr|
      ["#{attr.name}_from", "#{attr.name}_to"]
    }.flatten,
  boolean:
    (attrs_with_type[:boolean] || []).flatten.map(&:name),
  references:
    (attrs_with_type[:references] || []).flatten.map(&:name)
}
-%>
    attr_accessor :<%= search_attrs.values.flatten.compact.join(", :") %>

<%- if search_attrs[:integer].present? -%>
          type_int :<%= search_attrs[:integer].join(", :") %>
<%- end -%>
<%- if search_attrs[:boolean].present? -%>
         type_bool :<%= search_attrs[:boolean].join(", :") %>
<%- end -%>
<%- if search_attrs[:date].present? -%>
         type_date :<%= search_attrs[:date].join(", :") %>
<%- end -%>

    def search(page)
      model = <%= class_name %>.active

<%- attributes.each do |attribute| -%>

  <%-
    case attribute.type
    when :string, :text -%>
      model = model.like(:<%= attribute.name %>, "%#{self.<%= attribute.name %>}%") if self.<%= attribute.name %>.present?
  <%- when :date, :time, :date_time, :timestamp, :integer, :float, :decimal -%>
      model = model.between(:<%= attribute.name %>, self.<%= attribute.name %>_from, self.<%= attribute.name %>_to)
  <%- when :boolean -%>
      if self.<%= attribute.name %>.present?
        model = model.where(<%= attribute.name %>: self.<%= attribute.name %> )
      end
  <%- when :references -%>
      self.<%= attribute.name %>.try(:delete, "")
      if self.<%= attribute.name %>.present?
        model = model.where(<%= attribute.name %>_id: self.<%= attribute.name %> )
      end
  <%- end -%>
<%- end -%>

      model.page(page)
    end
  end
end
<% end -%>