defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 52 cards" do
    deck_length = length(Cards.create_deck)
    assert deck_length == 52
  end

  test "shuffled deck is randomized" do
    new_deck = Cards.create_deck
    refute new_deck == Cards.shuffle(new_deck)
  end
end
