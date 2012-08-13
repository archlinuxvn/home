# Bài viết đánh dấu với thẻ <%= @tag %>

<ol>
<% items_with_tag(@tag).each do |p| %>
  <li><%= link_to(p[:title], p.identifier) %> (<%= File.dirname(p.identifier) %>)</li>
<% end %>
</ol>
