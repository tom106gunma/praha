export default function Square({ value, onSquareClick, style }) {
  return (
    <button className="square" style={style} onClick={onSquareClick}>
      {value}
    </button>
  );
}
