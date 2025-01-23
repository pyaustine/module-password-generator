defmodule PasswordGeneratorTest do
  use ExUnit.Case


  # set up the test
  setup do
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, &<<&1>>),
      numbers: Enum.map(?0..?9, &Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbols: String.split("!#$%&()*+,-./:;<=>?@[]^_{|}~", "", trim: true) # trim true to remove the empty string and whitespace
    }

    # pattern match
    {:ok, result} = PasswordGenerator.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  # test the result we get back is a strinf
  test "returns a string", %{result: result} do
    assert is_bitstring(result)
  end

  # test the length of the result
  test "returns error when no length is provided" do
    options = %{"invalid" => "false"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  # test the length of the options map and return error when length is not an integer
  test "returns error when length is not an integer" do
    options = %{"length" => "ab"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  # test the length of the string returned to match the length of the options provided
  test "length of the returned string is the options provided" do
    length_option = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)

    assert 5 = String.length(result)
  end

  # test the string returned is a lowercase string
  test "returns a lowercase string just with the length", %{options_type: options} do
    length_option = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)

    assert String.contains?(result, options.lowercase)

    # ensure that the result does not contain any numbers, uppercase or symbols
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end


  # test that the options provided are respected
  test "returns error when options values are not booleans" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end


  # test for invalid options
  test "return error when options are not allowed" do
    options = %{
      "length" => "5",
      "invalid" => "true"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  # test for invalid options
  test "returns error when 1 option not allowed" do
    options = %{
      "length" => "5",
      "numbers" => "true",
      "invalid" => "true"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end


  # test for uppercase

  test "returns a string with uppercase letters", %{options_type: options} do
    options_with_uppercase = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_uppercase)

    assert String.contains?(result, options.uppercase)

    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end

  # test for numbers
  test "returns a string with numbers", %{options_type: options} do
    options_with_numbers = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_numbers)

    assert String.contains?(result, options.numbers)

    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)

  end

  # test for uppercase and numbers
  test "returns a string with uppercase and numbers", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.uppercase)
    assert String.contains?(result, options.numbers)

    refute String.contains?(result, options.symbols)
  end


  # test for symbols
  test "returns a string with symbols", %{options_type: options} do
    options_with_symbols = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_symbols)

    assert String.contains?(result, options.symbols)

    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
  end


   # test for uppercase and symbols
  test "returns a string with uppercase and symbols", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.uppercase)
    assert String.contains?(result, options.symbols)

    refute String.contains?(result, options.numbers)
  end


  # test for numbers and symbols
  test "returns a string with numbers and symbols", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.symbols)

    refute String.contains?(result, options.uppercase)
  end

  # test for uppercase, numbers and symbols
  test "returns a string with uppercase, numbers and symbols", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.uppercase)

  end


end
