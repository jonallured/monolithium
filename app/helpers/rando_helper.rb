module RandoHelper
  def rando_result(random_pick)
    winner = random_pick.game.winning_team.name
    loser = random_pick.game.losing_team.name

    if random_pick.correct?
      result = 'No points this week'
      picks = "Rando's pick was the #{winner}, who beat the #{loser}."
    else
      result = 'Points this week'
      picks = "Rando's pick was the #{loser}, who beat the #{winner}."
    end

    [result, picks].join(' - ')
  end

  def pick_result(pick)
    return '-' unless pick.game_complete?
    pick.correct? ? 'Won' : 'Lost'
  end

  def character_status(character)
    character.out ? 'Out' : 'In'
  end
end
