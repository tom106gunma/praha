import Square from './Square';

export default {
  title: 'Components/Square',
  component: Square,
};

export const Default = () => <Square value="X" onSquareClick={() => alert('Square clicked!')} />;
export const Empty = () => <Square value={null} onSquareClick={() => alert('Square clicked!')} />;
export const O = () => <Square value="O" onSquareClick={() => alert('Square clicked!')} />;
