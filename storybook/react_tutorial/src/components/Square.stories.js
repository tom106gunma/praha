import Square from './Square';

export default {
  title: 'Components/Square',
  component: Square,
};

export const Default = () => <Square value="X" style={{ color: 'red' }} onSquareClick={() => alert('Square clicked!')} />;
export const Empty = () => <Square value={null} style={{ color: 'red' }} onSquareClick={() => alert('Square clicked!')} />;
export const O = () => <Square value="O" style={{ color: 'red' }} onSquareClick={() => alert('Square clicked!')} />;
