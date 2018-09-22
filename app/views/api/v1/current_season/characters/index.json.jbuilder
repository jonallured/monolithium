json.array! current_characters do |character|
  json.id character.id
  json.player_name character.player_name
  json.out character.out
  json.picks character.current_picks, :week_number, :team_id
end
