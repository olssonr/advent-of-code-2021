def main():
    with open("day6_puzzle_input.txt", encoding="utf-8") as file:
        content = file.read()
    numbers = [int(number) for number in content.split(",")]

    counter_dictionary = build_dictionary_counter(numbers)
    for _ in range(80):
        counter_dictionary = forward_day(counter_dictionary)
    print(f"Part one: {sum(counter_dictionary.values())}")

    counter_dictionary = build_dictionary_counter(numbers)
    for _ in range(256):
        counter_dictionary = forward_day(counter_dictionary)
    print(f"Part two: {sum(counter_dictionary.values())}")

def forward_day(current_day):
    next_day = {}
    for timer_value in range(8):
        next_day[timer_value] = current_day[timer_value+1]

    next_day[8] = current_day[0]
    next_day[6] += current_day[0]

    return next_day


def build_dictionary_counter(numbers):
    return {timer_value: numbers.count(timer_value) for timer_value in range(9)}


if __name__ == "__main__":
    main()
