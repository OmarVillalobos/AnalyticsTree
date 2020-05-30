library(tidyverse)
library(gapminder)
library(dplyr)
library(ggplot2)

gapminder %>%
  filter(year == 1957)


gapminder %>%
  filter(country == "Austria")

gapminder %>%
  arrange(pop)

gapminder %>%
  filter(year == 1957) %>%
  arrange(desc(pop)) %>%
  mutate(pop = pop/1000000)

# Use mutate to change lifeExp to be in months
# Use mutate to create a new column called lifeExpMonths
gapminder %>%
  mutate(lifeExpMonths = lifeExp*12) %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExpMonths))

##### ggplot2 

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, 
                           size = pop)) + 
  geom_point() + scale_x_log10() + 
  facet_wrap(~year)


##### Summarize 
gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp), totalPop = sum(as.numeric(pop)))


# Summarize to find the median life expectancy

gapminder %>%
  group_by(year, continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdp = max(gdpPercap))

##### 
# Find median life expectancy and maximum GDP per capita in each year
gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdp = max(gdpPercap))

# Find median life expectancy and maximum GDP per capita in each continent in 1957
gapminder %>%
  filter(year == 1957)
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdp = max(gdpPercap))

# Find median life expectancy and maximum GDP per
# capita in each continent/year combination
gapminder %>%
  group_by(year, continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdp = max(gdpPercap))

##### Histograma 
ggplot(gapminder, aes(x = lifeExp)) + 
  geom_histogram(binwidth = 2)


