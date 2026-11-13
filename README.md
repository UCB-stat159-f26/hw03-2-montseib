#  tenniscareers.r

Retrieve a tennis player's career matches from [tennisabstract.com](https://www.tennisabstract.com/)
and plot the age gap between the player and each opponent, similar to the
New York Times visualization of Serena Williams' career.

## Installation

Install the development version from GitHub:

```r
# using devtools
devtools::install_github("montseib/hw03-2-montseib")

# or using pak
pak::pak("montseib/hw03-2-montseib")

```


## Usage

The package has two public functions:

| Function | Purpose |
|----------|---------|
| `get_player_career(player_name)` | Downloads and cleans a player's career matches, returning a data frame |
| `plot_age_gap(career_data)` | Takes that data frame and returns a scatter plot |

```r
library(tennisage)

# Serena Williams
serena <- get_player_career("serena williams")
plot_age_gap(serena)

# Rafael Nadal
rafa <- get_player_career("Rafael Nadal")
plot_age_gap(rafa)
```

Names can be written in several ways: `"serena williams"`, `"Serena Williams"`
and `"SerenaWilliams"` all work.

An unknown player gives an informative error:

```r
get_player_career("GastonSanchez")
#> Error: Player 'GastonSanchez' was not found on tennisabstract.com. Check the spelling.
```

## The data

`get_player_career()` returns one row per match, sorted by date, with columns:

| Column | Description |
|--------|-------------|
| `date` | Match date |
| `tournament` | Tournament name |
| `surface` | Court surface |
| `round` | Round played |
| `result` | `"W"` or `"L"` from the player's point of view |
| `score` | Match score |
| `opponent` | Opponent's name |
| `opponent_rank` | Opponent's ranking at the time |
| `opponent_country` | Opponent's country code |
| `player_age` | Player's age (years) on the match date |
| `opponent_age` | Opponent's age (years) on the match date |
| `age_diff` | `player_age - opponent_age` |

## The plot

`plot_age_gap()` returns a `ggplot` object, so you can customize it further:

```r
library(ggplot2)

plot_age_gap(serena) +
  labs(title = "Serena Williams: age gap with opponents")
```

- x-axis: the player's age
- y-axis: the player's age minus the opponent's age (positive means the player was older)
- color: win or loss

## How it works

1. The player's name is converted to the format used in tennisabstract URLs
   (for example `"SerenaWilliams"`).
2. The player's page is fetched to confirm the player exists and to read their
   date of birth. The women's page is tried first, then the men's.
3. The career JavaScript file (`/jsmatches/<Name>Career.js`) is downloaded and
   its match arrays are parsed.
4. Ages are computed. Women's files list each opponent's date of birth, so the
   age is derived from it. Men's files already give the opponent's age.

## Tests

Tests do not contact the website. They use small mock JavaScript snippets (one
women's and one men's format) to check the parsing and age calculations.

```r
devtools::test()
```
## Data source

All data comes from [Tennis Abstract](https://www.tennisabstract.com/). This
package is not affiliated with that site.

## Personal Reflection
