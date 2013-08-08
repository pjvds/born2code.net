# Check status is 200
status_code=$(curl --write-out %{http_code} --silent --output "site-content.html" "$SITE_URL")
if [ $status_code -ne 200 ]; then
  fail "Deploy failure: site returned $status_code, 200 was expected";
else
  info "Status code is correct: $status_code";
fi

# Check title is correct
title=$(awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}' site-content.html)
if [ $title != 'born2code.net' ]; then
  fail "Unexpected title '$title' for $SITE_URL";
else
  info "Title is correct: $title";
fi

# We reached the end of the script
success 'Post deploy tests succeeded'
