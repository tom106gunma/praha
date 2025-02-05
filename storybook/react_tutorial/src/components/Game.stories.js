import React from 'react';
import { userEvent, within } from '@storybook/testing-library';
import { expect } from '@storybook/jest';

import Game from './Game';

export default {
  title: 'Components/Game',
  component: Game,
} ;

const Template = (args) => <Game {...args} />;

export const Default = () => <Game />;

export const WinnerX = Template.bind({});
WinnerX.play = async ({ canvasElement }) => {
  const canvas = within(canvasElement);

  const squareButtons = canvas.getAllByRole('button');

  await userEvent.click(squareButtons[0]);
  await userEvent.click(squareButtons[3]);
  await userEvent.click(squareButtons[1]);
  await userEvent.click(squareButtons[4]);
  await userEvent.click(squareButtons[2]);

  expect(canvas.getByText("Winner: X")).toBeInTheDocument();
};
