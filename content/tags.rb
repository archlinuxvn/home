---
title: Thẻ (tag) đánh dấu bài viết
virtual: true
---

<ul>
<% all_tags.each do |tag, count| %>
  <li><%= link_for_tag(tag, "/tags/") %> (<%= count %> bài)</li>
<% end %>
</ul>
