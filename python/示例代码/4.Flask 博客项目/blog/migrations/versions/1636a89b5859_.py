"""empty message

Revision ID: 1636a89b5859
Revises: aae1a5342310
Create Date: 2020-07-21 09:27:47.679133

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '1636a89b5859'
down_revision = 'aae1a5342310'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_unique_constraint(None, 'user', ['email'])
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'user', type_='unique')
    # ### end Alembic commands ###
