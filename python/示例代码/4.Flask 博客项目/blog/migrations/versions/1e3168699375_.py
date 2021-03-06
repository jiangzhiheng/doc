"""empty message

Revision ID: 1e3168699375
Revises: acd492ac452f
Create Date: 2020-07-21 15:29:01.969568

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '1e3168699375'
down_revision = 'acd492ac452f'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('user',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('username', sa.String(length=12), nullable=True),
    sa.Column('password_hash', sa.String(length=128), nullable=True),
    sa.Column('sex', sa.Boolean(), nullable=True),
    sa.Column('age', sa.Integer(), nullable=True),
    sa.Column('email', sa.String(length=50), nullable=True),
    sa.Column('icon', sa.String(length=70), nullable=True),
    sa.Column('lastLogin', sa.DateTime(), nullable=True),
    sa.Column('registerTime', sa.DateTime(), nullable=True),
    sa.Column('confirm', sa.Boolean(), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email')
    )
    op.create_index(op.f('ix_user_username'), 'user', ['username'], unique=True)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_user_username'), table_name='user')
    op.drop_table('user')
    # ### end Alembic commands ###
