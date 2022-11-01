#include <stdio.h>

void	ft_swap(int *a, int *b)
{
	int temp = *a;
	*a = *b;
	*b = temp;
}

void	ft_rev_int_tab(int *tab, int size)
{
	int i = 0;

	while (i < size / 2)
	{
		// Je swap la valeur tab[i] avec la valeur tab[size - i - 1] (la valeur opposé à tab[i])
		ft_swap(tab[i], tab[size - i - 1]);
		i++;
	}
}

int	main(void)
{
	int tab[] = {1, 2, 3, 4, 5, 6, 7};
	int size = 7;

	ft_rev_int_tab(tab, size);
	return 0;
}