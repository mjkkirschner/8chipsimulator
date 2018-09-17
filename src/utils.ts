
//TODO MOVE THESE TO UTILS
export function hex2BinArray(hexString: string) {
    let binString = convertNumber(hexString, 16, 2);
    return binString.padStart(16, "0").split('').map(x => { return parseInt(x) });
  }

  function convertNumber(n: string, fromBase: number, toBase: number): string {
    if (fromBase === void 0) {
      fromBase = 10;
    }
    if (toBase === void 0) {
      toBase = 10;
    }
    return (parseInt(n, fromBase)).toString(toBase);
  }