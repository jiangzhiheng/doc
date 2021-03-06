"""empty message

Revision ID: 79352089b536
Revises: 1e3168699375
Create Date: 2020-07-23 10:14:36.250837

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '79352089b536'
down_revision = '1e3168699375'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('posts',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sa.String(length=20), nullable=True),
    sa.Column('article', sa.Text(), nullable=True),
    sa.Column('pid', sa.Integer(), nullable=True),
    sa.Column('path', sa.Text(), nullable=True),
    sa.Column('visit', sa.Integer(), nullable=True),
    sa.Column('timestamp', sa.DateTime(), nullable=True),
    sa.Column('uid', sa.Integer(), nullable=True),
    sa.Column('state', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['uid'], ['user.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_posts_title'), 'posts', ['title'], unique=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_posts_title'), table_name='posts')
    op.drop_table('posts')
    # ### end Alembic commands ###
