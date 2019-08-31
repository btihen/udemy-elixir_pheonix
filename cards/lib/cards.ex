defmodule Cards do
  @moduledoc """
    Creates and handles a deck of cards
  """
  @doc """
    creates a deck
  """
   def create_deck do
    # ["Ace", "Two", "Three", "Four", "Five"]
    #
    suits  = [ "Clubs", "Diamonds", "Hearts", "Spades" ]
    values = [ "Ace", "Two", "Three", "Four", "Five",
               "Six", "Seven", "Eight", "Nine", "Ten",
               "Jack", "Queen", "King" ]
    # list comprehension (nested array) - then flatten
    # for suit <- suits do
    #   for value <- values do
    #     "#{value} of #{suit}"
    #   end
    # end |> List.flatten
    #
    # nested comprehensions (to make each possibility)
    for suit <- suits, value <- values do
       "#{value} of #{suit}"
    end
  end


  @doc """
    Determines if a card is within the deck

    ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Clubs")
      true

  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def shuffle(deck) do
    deck |> Enum.shuffle
  end

  @doc """
    Divides a deck into a hand and the rest of the deck.
    The `hand_size` is the cards delt to the hand

    ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, _deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Clubs"]

  """
  def deal(deck, hand_size) do
    deck |> Enum.split(hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    # {status, binary_deck} = File.read(filename)
    # case status do
    #   :ok    -> :erlang.binary_to_term(binary_deck)
    #   :error -> "File doesn't exist"
    # end
    #
    # little more efficient
    case File.read(filename) do
      {:ok, binary_deck} ->   :erlang.binary_to_term(binary_deck)
      {:error, :enoent } -> "File doesn't exist"
      {:error, reason }  -> "Error: #{reason}"
    end
  end

  def create_hand(hand_size\\5) do
    create_deck()
    |> shuffle()
    |> deal(hand_size)
  end

end
