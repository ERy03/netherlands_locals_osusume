json.inserted_item render(partial: "recommendations/review_card", formats: :html, locals: { review: @review })
json.new_review_count @recommendation.reviews.count
json.new_rating_count @recommendation.rating
