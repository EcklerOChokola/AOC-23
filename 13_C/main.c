#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int convert_line(const char *line) {
	int result = 0;
	for (size_t i = 0; i < strlen(line); i++)
	{
		if (line[i] == '#') {
			result |= 1 << i;
		} 
	}
	return result;
}

int read_block(char chars[20][20], FILE *file) {
	char line[20];
	fgets(line, 20, file);
	int line_len = strlen(line) - 1;
	int cursor = 0;
	while (convert_line(line))
	{
		for(size_t i = 0; i < line_len; i++) {
			chars[cursor][i] = line[i];
		}
		cursor++;
		if (feof(file)) {
			break;
		}
		fgets(line, 20, file);
	}
	return cursor + 100 * line_len;
}

int main(int argc, char **argv) {
	//int_stack_t stack = { .cursor = 0 };
	int part_one = 0;
	int part_two = 0;

	FILE* file = fopen("input.txt", "r");
	while (!feof(file))
	{		
		/*  FIRST TRY, with a stack and integers representing each row 
			and column as a binary string with 1 for # and 0 for .
		clear(&stack);
		int mirrored = 0;
		int horizontals[20], verticals[20];
		int res = read_block(horizontals, verticals, file);
		int counth = res % 100;
		int countv = res / 100;
		printf("\n -------- \n");
		printf("%d    %d\n", counth, countv);
		for (size_t i = 0; i < counth; i++) {
			if (isEmpty(&stack)) {
				push(&stack, horizontals[i]);
				continue;
			}
			int temp = pop(&stack);
			if (temp == horizontals[i]) {
				mirrored++;
				if (size(&stack) == 0) {
					printf("mirrored horizontally at : %d\n", mirrored);
					part_one += mirrored * 100;
					break;
				}
				if (i == counth - 1)
				{
					printf("mirrored horizontally at : %d\n", counth - mirrored);
					part_one += (counth - mirrored) * 100;
					break;
				}	
			} else {
				push(&stack, temp);
				push(&stack, horizontals[i]);
			}
		}
		clear(&stack);
		mirrored = 0;
		for (size_t i = 0; i < countv; i++) {
			if (isEmpty(&stack)) {
				push(&stack, verticals[i]);
				continue;
			}
			int temp = pop(&stack);
			if (temp == verticals[i]) {
				mirrored++;
				if (size(&stack) == 0) {
					printf("stack mirrored vertically at : %d\n", mirrored);
					part_one += mirrored;
					break;
				}
				if (i == countv - 1)
				{
					printf("count mirrored vertically at : %d\n", countv - mirrored);
					part_one += countv - mirrored;
					break;
				}	
			} else {
				push(&stack, temp);
				push(&stack, verticals[i]);
			}
		}
		*/
		char chars[20][20];
		int res = read_block(chars, file);
		int counth = res % 100;
		int countv = res / 100;

		printf("%d %d\n", counth, countv);
		for (int column = 0; column < countv - 1; column++) {
			int smudges = 0;
			for (int i = 0; i < countv; i++) {
				int l = column - i;
				int r = column + 1 + i;
				if (0 <= l && l < r && r < countv) {
					for (int row = 0; row < counth; row++) {
						if (chars[row][l] != chars[row][r]) {
							smudges++;
						}
					}
				}
			}
			if (!smudges) {
				printf("VERT  %d\n", column + 1);
				part_one += column + 1;
			}
			if (smudges == 1) {
				part_two += column + 1;
			}
		}

		for (int row = 0; row < counth - 1; row++) {
			int smudges = 0;
			for (int i = 0; i < counth; i++) {
				int u = row - i;
				int d = row + 1 + i;
				if (0 <= u && u < d && d < counth) {
					for (int column = 0; column < countv; column++) {
						if (chars[u][column] != chars[d][column]) {
							smudges++;
						}
					}
				}
			}
			if (smudges == 0) {
				printf("HOR  %d\n", row + 1);
				part_one += (row + 1) * 100;
			}
			if (smudges == 1) {
				part_two += (row + 1) * 100;
			}
		}
	}
	printf("Part 1 : %d\n", part_one);
	printf("Part 2 : %d\n", part_two);

	fclose(file);
	return 0;
}