/* eslint-disable */

import React from 'react';
import { Svg, Path } from 'react-native-svg';
import { getIconColor } from './helper';

let Shanchubiaoge = ({ size, color, ...rest }) => {
  return (
    <Svg viewBox="0 0 1024 1024" width={size} height={size} {...rest}>
      <Path
        d="M870.741333 659.541333l48.256 48.256-81.408 81.365334 81.536 81.578666-48.256 48.256-81.536-81.578666-81.493333 81.578666-48.298667-48.256 81.493334-81.578666-81.365334-81.365334 48.256-48.256 81.408 81.322667 81.408-81.322667zM810.666667 170.666667a42.666667 42.666667 0 0 1 42.666666 42.666666v426.666667h-213.333333v170.666667H213.333333a42.666667 42.666667 0 0 1-42.666666-42.666667V213.333333a42.666667 42.666667 0 0 1 42.666666-42.666666h597.333334zM384 640H213.333333v106.666667a21.333333 21.333333 0 0 0 17.493334 20.992L234.666667 768H384v-128z m213.333333 0h-170.666666v128h170.666666v-128z m0-170.666667h-170.666666v128h170.666666v-128z m213.333334 0h-170.666667v128h170.666667v-128zM384 469.333333H213.333333v128h170.666667v-128z m213.333333-170.666666h-170.666666v128h170.666666V298.666667z m192 0H640v128h170.666667V320a21.333333 21.333333 0 0 0-17.493334-20.992L789.333333 298.666667zM384 298.666667H234.666667a21.333333 21.333333 0 0 0-20.992 17.493333L213.333333 320V426.666667h170.666667V298.666667z"
        fill={getIconColor(color, 0, '#333333')}
      />
    </Svg>
  );
};

Shanchubiaoge.defaultProps = {
  size: 18,
};

Shanchubiaoge = React.memo ? React.memo(Shanchubiaoge) : Shanchubiaoge;

export default Shanchubiaoge;
