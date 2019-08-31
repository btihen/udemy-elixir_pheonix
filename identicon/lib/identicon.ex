defmodule Identicon do
  use Vivid
  @moduledoc """
  Identicon - 5x5 image (50px x 50px - mirrored vertically)
  seed with string same string generates same ideticon
  String -> Image
  """

  def generate(username, px_size\\50) do
    username
    |> md5_hash
    |> add_grid
    |> add_color
    |> min_grid_points
    |> build_pixel_map(px_size)
  end

  def image(username, px_size\\30) do
    username
    |> generate(px_size)
    |> draw_image(px_size)
    |> save_image(username) # fast!
  end

  def vivid(username, px_size\\5) do
    username
    |> generate(px_size)
    |> generate_vivid(px_size)
  end


  def vivid_text(username, px_size\\30) do
    image = vivid(username, px_size)
    IO.puts "to string - SLOW!"
    image
      |> to_string  # SLOW!
      |> IO.puts
  end

  def vivid_image(username, px_size\\40) do
    image = vivid(username, px_size)
    IO.puts "to png - SLOW!"
    image |> save_vivid(username) # SLOW!
  end

  def save_vivid(image_frame, username) do
    image_frame |> Vivid.PNG.to_png("#{username}.png")
  end

  def generate_vivid(%Identicon.Image{color: {red,green,blue},
                                      pixels: pixels,
                                      min_grid: _grid}, px_size\\50) do
    r = red / 256
    g = green / 256
    b = blue / 256
    rgba  = RGBA.init(r,g,b,1)
    frame = Frame.init(5*px_size, 5*px_size, RGBA.white)
    Enum.reduce pixels, frame, fn({{top_x, top_y}, {bottom_x, bottom_y}}, new_img) ->
      start_point = Point.init(top_x,top_y)
      stop_point  = Point.init(bottom_x,bottom_y)
      box = Box.init(start_point, stop_point, true)
      Frame.push(new_img, box, rgba)
    end
  end

  def save_image(bin_image, username) do
    File.write("#{username}.png", bin_image)
  end

  def draw_image(%Identicon.Image{color: color, pixels: pixels}, px_size\\50) do
    image = :egd.create(5*px_size, 5*px_size)  # creates a blank image
    fill  = :egd.color(color)
    Enum.each pixels, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end
    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{min_grid: grid} = image, px_size\\50) do
    pixels = Enum.map grid, fn({_even, index}) ->
      top_x        = rem(index, 5) * px_size
      top_y        = div(index, 5) * px_size
      top_left     = {top_x, top_y}
      bottom_right = {top_x + px_size-1, top_y + px_size-1}
      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixels: pixels}
  end

  def min_grid_points(%Identicon.Image{grid: grid} = image) do
    slim_grid = Enum.filter grid,
                            fn({switch, _location})
                              -> rem(switch,2) == 0  end

    %Identicon.Image{image | min_grid: slim_grid}
  end

  def add_grid(%Identicon.Image{hex: list} = image) do
    grid =
      list
      |> Enum.chunk_every(3, 3, :discard) # [[1,2,3],[4,5,6],...]
      |> Enum.map(&mirror_row/1 )         # |> Enum.map(fn row -> mirror_row(row) end )
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  defp mirror_row(row) do
    [first, second | _rest] = row  # [145, 46, 200]
    row ++ [second, first]         # [145, 46, 200, 46, 145]
  end

  defp add_color(%Identicon.Image{hex: [red, green, blue | _rest]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  defp md5_hash(username) do
    # :crypto.hash(:md5 , username) |> Base.encode16(case: :lower)
    md5_hex = :crypto.hash(:md5 , username)
              |> :binary.bin_to_list
    %Identicon.Image{hex: md5_hex}
  end

end
