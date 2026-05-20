export interface Allergen {
  code: number;
  name: string;
}

export const ALLERGENS_LIST: Allergen[] = [
  { code: 1, name: 'Pescado' },
  { code: 2, name: 'Frutos secos' },
  { code: 3, name: 'Lácteos' },
  { code: 4, name: 'Moluscos' },
  { code: 5, name: 'Gluten' },
  { code: 6, name: 'Crustáceos' },
  { code: 7, name: 'Huevos' },
  { code: 8, name: 'Cacahuetes' },
  { code: 9, name: 'Soja' },
  { code: 10, name: 'Apio' },
  { code: 11, name: 'Mostaza' },
  { code: 12, name: 'Sésamo' },
  { code: 13, name: 'Altramuz' },
  { code: 14, name: 'Sulfitos' }
];

export const ALLERGEN_MAP: Record<number, string> = ALLERGENS_LIST.reduce((acc, curr) => {
  acc[curr.code] = curr.name;
  return acc;
}, {} as Record<number, string>);

/**
 * Parses allergen codes from string (e.g. "1, 5, 7" or "1/5") into a sorted array of numbers
 */
export const parseAllergenCodes = (codesStr: string | null): number[] => {
  if (!codesStr) return [];
  return codesStr
    .split(/[,/;\s]+/)
    .map(code => parseInt(code.trim(), 10))
    .filter(num => !isNaN(num) && num >= 1 && num <= 14)
    .sort((a, b) => a - b);
};
