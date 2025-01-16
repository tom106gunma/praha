import Board from './Board';
import { action } from '@storybook/addon-actions';

export default {
  title: 'Components/Board',
  component: Board,
};

const Template = (args) => <Board {...args} />;

export const Default = Template.bind({});
Default.args = {
  xIsNext: true,
  squares: ['X', 'X', 'O', null, null, null, 'O', null, null],
  onPlay: action('onPlay'),
};

export const WinnerX = Template.bind({});
WinnerX.args = {
  xIsNext: false,
  squares: ['X', 'X', 'X', null, 'O', null, 'O', null, null],
  onPlay: action('onPlay'),
};

export const AllTriangle = Template.bind({});
AllTriangle.args = {
  xIsNext: true,
  squares: ['△', '△', '△', '△', '△', '△', '△', '△', '△'],
  onPlay: action('onPlay'),
};
